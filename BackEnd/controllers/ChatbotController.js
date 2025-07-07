const configureGemini = require("../config/ai-config");
const asyncWrapper = require("../middleware/asyncWrapper");
const httpStatusText = require("../utils/httpStatusText");
const appError = require("../utils/appError");
const Patient = require("../models/Patient");

const askChatbot = asyncWrapper(async (req, res, next) => {
  const { message } = req.body;
  const id = req.currentUser.id;
  try {
    const patient = await Patient.findById(id);
    if (!patient) {
      const error = appError.create('Patient not found', 404, httpStatusText.FAIL);
      return next(error);
    }
    // const chats = patient.chats.map(({ role, content }) => content);
    // chats.push(message);
    patient.chats.push({ role: "user", content: message });

    const genAI = configureGemini();
    const model = genAI.getGenerativeModel({ 
        model: "gemini-2.5-flash-preview-05-20",
        systemInstruction: {
            parts: [
                {
                    text: `You are a highly specialized AI assistant focused exclusively on providing information related to human health and medicine.
                    Your responses must be factual, evidence-based, and strictly limited to medical topics.
                    you must provide advice, diagnoses, and medicines. Always recommend consulting a qualified healthcare professional for medical concerns.
                    If a query is outside the scope of human health and medicine, you must politely decline to answer, stating that you are only equipped to handle medical inquiries.`
                },
            ]
        }
    }); 
    const chat = model.startChat({
        history: patient.chats.map(({ role, content }) => ({ role, parts: [{ text: content }] })),
    });

    const result = await chat.sendMessage(message);
    const response = await result.response;
    const generatedText = response.text();
    const cleanedText = generatedText.replace(/\*/g, "");
    patient.chats.push({ role: "model", content: cleanedText });
    await patient.save();
    return res.status(200).json({ status: httpStatusText.SUCCESS, data:{response: cleanedText} });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Something went wrong" });
  }
});

const deleteChat = asyncWrapper(async(req, res, next) => {
    const id = req.currentUser.id;
    const patient = await Patient.findById(id);
    if (!patient) {
        const error = appError.create('Patient not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    patient.chats = [];
    await patient.save();
    res.status(200).json({status: httpStatusText.SUCCESS, data: null});
});

module.exports = { 
  askChatbot, 
  deleteChat 
};