module main

import os
import flag
import time

fn parse_args() Config {
	mut fp := flag.new_flag_parser(os.args)
	fp.application('stress')
	fp.version('0.1.0')
	fp.description('Simple HTTP stress tester')

	show_help := fp.bool('help', `h`, false, 'Show help message')

	url := fp.string('url', `u`, '', 'Target URL (required)')
	concurrency := fp.int('concurrency', `c`, 10, 'Number of concurrent workers')
	duration_str := fp.string('duration', `d`, '10s', 'Test duration (e.g., 10s, 1m, 1m30s, 250ms)')
	method := fp.string('method', `m`, 'GET', 'HTTP method to use (GET or POST)')
	mut body := fp.string('body', `b`, '', 'Request body literal (for POST method)')
	body_file := fp.string('body-file', `f`, '', 'File path to load request body (for POST method)')

	_ := fp.finalize() or {
		eprintln(err)
		println(fp.usage())
		exit(1)
	}

	if show_help {
		println(fp.usage())
		exit(0)
	}

	dur := parse_duration(duration_str) or {
		eprintln('Invalid duration format')
		exit(1)
	}

	if url == '' {
		eprintln('Error: URL is required')
		exit(1)
	}

	if body_file != '' {
		body = os.read_file(body_file) or {
			eprintln('Error reading body file: ${err}')
			exit(1)
		}
	}

	return Config{
		url:         url
		concurrency: concurrency
		duration:    dur
		method: 		 method.to_upper()
		body:        body
	}
}

fn main() {	
	cfg := parse_args()
	stop_at := time.now().add(cfg.duration)
	ch := chan Result{cap: cfg.concurrency}

	println('Running stress test on ${cfg.url} with ${cfg.concurrency} workers for ${cfg.duration} using method ${cfg.method}')
	if cfg.method == 'POST' && cfg.body.len > 0 {
		println('With request body: ${cfg.body}')
	}

	for i in 0..cfg.concurrency {
		spawn worker(i, cfg, ch, stop_at)
	}

	mut results := []Result{}
	mut last_print := time.now()
	mut total_reqs := 0

	for {
		if time.now() >= stop_at && ch.len == 0 { break }
		res := <- ch or { break }
		results << res
		total_reqs++

		if (time.now() - last_print).seconds() >= 1 {
			println('Requests so far: ${total_reqs}')
			last_print = time.now()
		}
	}

	// Calculate metrics
	metrics(cfg, results)!
}
