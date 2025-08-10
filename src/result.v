module main

import time

pub struct Result {
	pub:
		success bool
		latency time.Duration
}

pub fn calculate_percentile(latencies []time.Duration, percentile f64) time.Duration {
	if latencies.len == 0 {
		return time.Duration(0)
	}

	mut sorted := latencies.clone()
	sorted.sort()

	rank := int(((percentile / 100.0) * f64(sorted.len - 1)) + 0.5)
	return sorted[rank]
}