function [low, high] = calculateFrequencyBounds(centerFreq, bandwidth)
    low = max(centerFreq - 0.5 * bandwidth, 100);
    high = min(centerFreq + 0.5 * bandwidth, 7999);
end