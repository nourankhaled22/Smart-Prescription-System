const redis = require('redis');

const redisClient = redis.createClient({ port: 6379 });

redisClient.connect()
    .then(() => console.log('Connected to Redis'))
    .catch(err => console.error('Redis connection error:', err));

async function getAllRedisData() {
    try {
        const keys = await redisClient.keys('*'); // Get all keys
        const allData = {};

        for (const key of keys) {
            const value = await redisClient.get(key);
            try {
                allData[key] = JSON.parse(value); // Parse if it's JSON
            } catch {
                allData[key] = value; // Return as-is if not JSON
            }
        }

        console.log(allData);
        return allData;
    } catch (err) {
        console.error('Error fetching Redis data:', err);
    }
}

module.exports = getAllRedisData