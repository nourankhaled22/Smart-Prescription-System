const { createClient } = require('redis');
// redis on railway -> url: process.env.REDIS_URL
// redis on localhost -> port:6380
// const redisClient = createClient({port:6380 });
const redisClient = createClient({url: process.env.REDIS_URL }); 

redisClient.on('error', (err) => {
    console.error('Redis Client Error:', err);
});

async function connectRedis() {
    if (!redisClient.isOpen) {
    await redisClient.connect();
    }
}

module.exports = { redisClient, connectRedis };
