const configureGemini = require("../config/ai-config");
const axios = require('axios');  // To read a file from a remote URL (like Cloudinary)

async function fileToBase64(fileUrl) {
    const response = await axios.get(fileUrl, {
        responseType: 'arraybuffer' // download as raw binary
    });
    const base64 = Buffer.from(response.data, 'binary').toString('base64');
    return base64;
}

const extractTextFromPrescription = async(prescriptionUrl) => {
    const genAI = configureGemini(); 
    const model = genAI.getGenerativeModel({
        model: 'gemini-2.5-flash-preview-05-20'
    });

    const base64Image = await fileToBase64(prescriptionUrl);

    const result = await model.generateContent({
        contents: [
            {
                role: 'user',
                parts: [
                    { text: `Extract all medicine names, doctor name and specialization from this prescription image. 
                            and return them in json format with keys 
                            {
                                doctor_name: doctor_name, 
                                medicines: medicines,
                                specialization: specialization
                            }
                            if there is no medicine name in the image, return json object contains this key
                            {
                                error: 'هذه ليست صورة وصفة طبية أو الصورة لا تحتوي على دواء'
                            }`
                    },
                    {
                    inlineData: {
                        mimeType: 'image/jpeg',
                        data: base64Image
                    }
                    }
                ]
            }
        ]
    });
    const response = await result.response;
    return response.text();
}

module.exports = extractTextFromPrescription;
