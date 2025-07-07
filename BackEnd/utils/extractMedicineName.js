const configureGemini = require("../config/ai-config");
const axios = require('axios');  // To read a file from a remote URL (like Cloudinary)

async function fileToBase64(fileUrl) {
    const response = await axios.get(fileUrl, {
        responseType: 'arraybuffer' // download as raw binary
    });
    const base64 = Buffer.from(response.data, 'binary').toString('base64');
    return base64;
}

const extractMedicineName = async(MedicineUrl) => {
    const genAI = configureGemini(); 
    const model = genAI.getGenerativeModel({
        model: 'gemini-2.5-flash-preview-05-20'
    });

    const base64Image = await fileToBase64(MedicineUrl);

    const result = await model.generateContent({
        contents: [
            {
                role: 'user',
                parts: [
                    { text: `Extract medicine name from this image. 
                            and return it in english in json format with keys 
                            medicine_name: medicine_name, 
                            if image is not medicine packet image or the image contains no medicine or image contains more than one medicine return json contains this fields
                            {
                                error: 'هذه ليس صورة دواء أو الصورة تحتوي على أكثر من دواء أو لا يوجد دواء في الصورة'
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

module.exports = extractMedicineName;