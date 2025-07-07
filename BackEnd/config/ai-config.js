const { GoogleGenerativeAI } = require("@google/generative-ai");

module.exports = () => {
    return new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
};
