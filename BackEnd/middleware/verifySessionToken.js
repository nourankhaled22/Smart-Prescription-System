const jwt = require('jsonwebtoken')
const httpStatusText = require('../utils/httpStatusText');
const appError = require('../utils/appError');
const verifySessionToken = (req, res, next) => {
    if (req.currentUser.role === "patient") {
        return next();
    }
    const sessionHeader = req.headers['SessionToken'] || req.headers['sessiontoken'];
    if(!sessionHeader) {
        const error = appError.create('session token is required', 401, httpStatusText.ERROR)
        return next(error);
    }
    const sessionToken = sessionHeader.split(' ')[1];
    try {
        const currentPatient = jwt.verify(sessionToken, process.env.JWT_SECRET_KEY);
        req.currentPatient = currentPatient;
        next();
    } catch (err) {
        const error = appError.create('invalid token', 401, httpStatusText.ERROR)
        return next(error);
    }  
}

module.exports = verifySessionToken