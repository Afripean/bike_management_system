package com.demo.util;

import java.util.concurrent.atomic.AtomicLong;

public class TokenBucket {
    private final long capacity;
    private final long refillTokens;
    private final long refillPeriod;
    private final AtomicLong availableTokens;
    private long lastRefillTimestamp;

    public TokenBucket(long capacity, long refillTokens, long refillPeriod) {
        this.capacity = capacity;
        this.refillTokens = refillTokens;
        this.refillPeriod = refillPeriod;
        this.availableTokens = new AtomicLong(capacity);
        this.lastRefillTimestamp = System.nanoTime();
    }

    public synchronized boolean tryConsume() {
        refill();
        if (availableTokens.get() > 0) {
            availableTokens.decrementAndGet();
            return true;
        }
        return false;
    }

    private void refill() {
        long now = System.nanoTime();
        long tokensToAdd = (now - lastRefillTimestamp) / refillPeriod * refillTokens;
        if (tokensToAdd > 0) {
            availableTokens.addAndGet(Math.min(tokensToAdd, capacity - availableTokens.get()));
            lastRefillTimestamp = now;
        }
    }
}
