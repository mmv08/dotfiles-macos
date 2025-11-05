#!/usr/bin/env python3
"""
Toggle macOS "natural scrolling" (swipe scroll direction) and apply immediately.

- Reads current value from the global domain key: com.apple.swipescrolldirection (true = natural scrolling on)
- Toggles the value and attempts to apply it live via PreferencePanesSupport.setSwipeScrollDirection
- Persists the setting using `defaults write`
- Prints the new state: "Natural scrolling: ON|OFF"

Usage:
  python3 $HOME/dotfiles-meta/scripts/toggle_natural_scrolling.py
  # or (after chmod +x) directly:
  $HOME/dotfiles-meta/scripts/toggle_natural_scrolling.py

Notes:
- Uses a private framework; future macOS updates may change behavior.
- No admin rights required. If live-apply fails, the stored preference is still updated.
"""
import subprocess
import sys
from ctypes import cdll, c_bool


def read_current_state() -> bool:
    try:
        out = subprocess.check_output([
            "defaults", "read", "-g", "com.apple.swipescrolldirection"
        ]).strip().lower()
        return out in (b"1", b"yes", b"true")
    except subprocess.CalledProcessError:
        # Key absent; default to True (natural on) per typical macOS defaults
        return True
    except Exception as exc:
        print(f"Error reading current state: {exc}", file=sys.stderr)
        sys.exit(1)


def apply_live_state(enabled: bool) -> None:
    """Try to apply without logout using PreferencePanesSupport; ignore if unavailable."""
    try:
        lib = cdll.LoadLibrary(
            "/System/Library/PrivateFrameworks/PreferencePanesSupport.framework/Versions/A/PreferencePanesSupport"
        )
        lib.setSwipeScrollDirection.argtypes = [c_bool]
        lib.setSwipeScrollDirection(c_bool(enabled))
    except Exception:
        # Best-effort only; continue to persist via defaults
        pass


def persist_state(enabled: bool) -> None:
    try:
        subprocess.run([
            "defaults", "write", "-g", "com.apple.swipescrolldirection", "-bool",
            "true" if enabled else "false"
        ], check=True)
    except subprocess.CalledProcessError as exc:
        print(f"Error persisting state: {exc}", file=sys.stderr)
        sys.exit(1)


def main() -> None:
    current = read_current_state()
    new_state = not current
    apply_live_state(new_state)
    persist_state(new_state)
    print(f"Natural scrolling: {'ON' if new_state else 'OFF'}")


if __name__ == "__main__":
    main()