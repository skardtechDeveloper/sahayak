const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { Configuration, OpenAIApi } = require('openai');
const cors = require('cors')({ origin: true });

admin.initializeApp();

const openaiConfig = new Configuration({
  apiKey: functions.config().openai.key,
});
const openai = new OpenAIApi(openaiConfig);

// AI Chat Completion API
exports.chatCompletion = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    try {
      const { prompt, language, userId, context } = req.body;
      
      // Validate request
      if (!prompt || !userId) {
        return res.status(400).json({ error: 'Missing required fields' });
      }
      
      // Rate limiting check
      const userRef = admin.firestore().collection('users').doc(userId);
      const userDoc = await userRef.get();
      
      if (userDoc.exists) {
        const userData = userDoc.data();
        const now = Date.now();
        const lastRequest = userData.lastRequest || 0;
        
        // Limit to 10 requests per minute for free users
        if (userData.subscription === 'free' && 
            now - lastRequest < 6000) {
          return res.status(429).json({ 
            error: 'Rate limit exceeded. Please upgrade to premium.' 
          });
        }
      }
      
      // Prepare system message based on language
      const systemMessage = language === 'ne' 
        ? 'तपाईं सहायक हुनुहुन्छ, नेपाली उपयोगकर्ताहरूलाई मद्दत गर्ने AI सहायक। नेपाली भाषामा जवाफ दिनुहोस्।'
        : 'You are Sahayak, a helpful AI assistant for Nepali users. Respond in English.';
      
      // Generate response using OpenAI
      const completion = await openai.createChatCompletion({
        model: "gpt-4-turbo-preview",
        messages: [
          { role: "system", content: systemMessage },
          ...(context || []).map(msg => ({ 
            role: msg.isUser ? "user" : "assistant", 
            content: msg.text 
          })),
          { role: "user", content: prompt }
        ],
        temperature: 0.7,
        max_tokens: 1000,
      });
      
      const responseText = completion.data.choices[0].message.content;
      
      // Log the interaction
      await admin.firestore().collection('chats').add({
        userId,
        prompt,
        response: responseText,
        language,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        tokensUsed: completion.data.usage.total_tokens
      });
      
      // Update user's last request time
      await userRef.update({
        lastRequest: Date.now(),
        requestsUsed: admin.firestore.FieldValue.increment(1)
      });
      
      res.json({ response: responseText });
      
    } catch (error) {
      console.error('Chat completion error:', error);
      res.status(500).json({ 
        error: 'Internal server error',
        details: error.message 
      });
    }
  });
});

// Document Processing Function
exports.processDocument = functions.storage.object().onFinalize(async (object) => {
  try {
    const filePath = object.name;
    const contentType = object.contentType;
    
    // Only process images
    if (!contentType.startsWith('image/')) {
      return null;
    }
    
    const bucket = admin.storage().bucket();
    const file = bucket.file(filePath);
    
    // Download the file
    const [fileBuffer] = await file.download();
    
    // Here you would integrate with your OCR service
    // For example, call Google Vision API
    const vision = require('@google-cloud/vision');
    const client = new vision.ImageAnnotatorClient();
    
    const [result] = await client.textDetection(fileBuffer);
    const detections = result.textAnnotations;
    const extractedText = detections[0] ? detections[0].description : '';
    
    // Save extracted text to Firestore
    const userId = filePath.split('/')[1]; // Extract userId from path
    await admin.firestore().collection('documents').add({
      userId,
      filePath,
      extractedText,
      processedAt: admin.firestore.FieldValue.serverTimestamp(),
      status: 'completed'
    });
    
    return null;
  } catch (error) {
    console.error('Document processing error:', error);
    return null;
  }
});

// Subscription Webhook
exports.handleSubscription = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    try {
      const { userId, subscriptionId, plan, status } = req.body;
      
      // Validate payment (integrate with payment gateway)
      const isValidPayment = await validatePayment(subscriptionId);
      
      if (!isValidPayment) {
        return res.status(400).json({ error: 'Invalid payment' });
      }
      
      // Update user subscription
      await admin.firestore().collection('users').doc(userId).update({
        subscription: plan,
        subscriptionStatus: status,
        subscriptionUpdated: admin.firestore.FieldValue.serverTimestamp(),
        tokens: plan === 'premium' ? 1000 : 100 // Give starting tokens
      });
      
      res.json({ success: true });
    } catch (error) {
      console.error('Subscription error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  });
});

async function validatePayment(subscriptionId) {
  // Implement payment validation logic
  // Integrate with Razorpay, Khalti, PayPal, etc.
  return true; // Placeholder
}

// Scheduled Function: Reset free tier limits
exports.resetFreeLimits = functions.pubsub
  .schedule('0 0 * * *') // Every day at midnight
  .timeZone('Asia/Kathmandu')
  .onRun(async (context) => {
    try {
      const usersRef = admin.firestore().collection('users');
      const snapshot = await usersRef
        .where('subscription', '==', 'free')
        .get();
      
      const batch = admin.firestore().batch();
      snapshot.docs.forEach(doc => {
        batch.update(doc.ref, {
          requestsUsed: 0,
          tokens: 100 // Reset to daily free tokens
        });
      });
      
      await batch.commit();
      console.log('Free tier limits reset successfully');
    } catch (error) {
      console.error('Error resetting limits:', error);
    }
  });