const multer = require('multer');
const { CloudinaryStorage } = require('multer-storage-cloudinary');
const cloudinary = require('../config/cloudinaryConfig');

const storage = new CloudinaryStorage({
    cloudinary: cloudinary,
    params: {
        folder: 'licences', // folder name on Cloudinary
        allowed_formats: ['jpg', 'jpeg', 'png', 'pdf'],
        transformation: [{ width: 800, crop: 'scale' }], // optional
        type: 'upload',                    // Make the file public
        resource_type: 'auto',            // auto-detects (image/pdf/etc.)
    }
});

const upload = multer({ storage });
module.exports = upload;