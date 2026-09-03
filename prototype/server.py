"""Installable PWA preview server for Otsrochka+ (not part of the iOS app)."""
import http.server
import functools
from pathlib import Path

DIR = Path(__file__).parent


class Handler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        **http.server.SimpleHTTPRequestHandler.extensions_map,
        ".webmanifest": "application/manifest+json",
        ".js": "text/javascript",
    }

    def end_headers(self):
        # Service worker must not be cached during development.
        if self.path.split("?")[0].endswith("/sw.js"):
            self.send_header("Cache-Control", "no-store")
        super().end_headers()


def run(port: int = 8080) -> None:
    handler = functools.partial(Handler, directory=str(DIR))
    with http.server.ThreadingHTTPServer(("127.0.0.1", port), handler) as httpd:
        print(f"Prototype at http://127.0.0.1:{port}/ (Ctrl+C to stop)")
        httpd.serve_forever()

if __name__ == "__main__":
    import sys
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    run(port)
