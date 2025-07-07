// examination name
// file name
// date

const mongoose = require('mongoose');

const examinationSchema = new mongoose.Schema({
    nationalId: {
        type: String,
        required: true,
        trim: true
    },
    
    examinationName: {
        type: String,
        required: true,
        trim: true
    },
    
    date: {
        type: Date,
        required: true
    },
    
    fileUrl: {
        type: String
    },

    filePublicId : {
        type: String
    }

    }, {
    timestamps: true
});

const Examination = mongoose.model('Examination', examinationSchema);

module.exports = Examination;
