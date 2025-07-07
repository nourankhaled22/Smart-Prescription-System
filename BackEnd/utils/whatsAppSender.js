const qrcode = require('qrcode-terminal');
const { Client, LocalAuth } = require('whatsapp-web.js');

let clientReady = false;
const client = new Client({
    authStrategy: new LocalAuth(),
    puppeteer: {
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    }
});

client.on('qr', qr => {
    qrcode.generate(qr, { small: true });
    console.log('Scan the QR code using WhatsApp on your phone');
});

client.on('ready', () => {
    console.log('WhatsApp client is ready!');
    // clientReady = true;
    // Add a slight delay to ensure internal setup is done
    setTimeout(() => {
        clientReady = true;
        console.log('WhatsApp client is fully initialized.');
    }, 3000); // 3 second delay
});

// Initialize client once
client.initialize();


async function sendWhatsAppMessage(phoneNumber, message) {
    if (!clientReady) {
        console.log("Waiting for WhatsApp client to be ready...");
        return new Promise((resolve, reject) => {
            client.on('ready', async () => {
                try {
                    const chatId = phoneNumber + '@c.us';
                    await client.sendMessage(chatId, message);
                    console.log(`Message sent to ${phoneNumber}`);
                    resolve();
                } catch (err) {
                    console.error('Error sending message:', err);
                    reject(err);
                }
            });
        });
    } else {
        try {
            const chatId = phoneNumber + '@c.us';
            await client.sendMessage(chatId, message);
            console.log(`Message sent to ${phoneNumber}`);
        } catch (err) {
            console.error('Error sending message:', err);
            throw err;
        }
    }
}

module.exports = sendWhatsAppMessage 