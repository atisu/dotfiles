---
name: video-transcript
description: Use OpenAI's Whisper to transcribe video on the local filesystem.
---

# YouTube Transcript Downloader

This skill helps download transcripts (subtitles/captions) from YouTube videos using yt-dlp.

## When to Use This Skill

Activate this skill when the user:
- Provides a video file and wants the transcript
- Asks to "transcript a video" or "get captions from a video" and provides a file path
- Wants to "get captions" or "get subtitles" from a video and provides a file path
- Asks to "transcribe a video" and provides a file path

## How It Works

### Priority Order:
5. **Whisper transcription**
7. **Optionally clean up** the VTT format if the user wants plain text

## Whisper Transcription (Last Resort)

### Step 1: Show File Size and Ask for Confirmation

Use the `du -h "<FILE_PATH>" | cut -f1` command to get the file size in human format, and display it with the filename to the user. If more than one file is requested, show the total size of all files combined. Ask the user: "The video file(s) you provided is/are approximately [SIZE]. Do you want to proceed with transcription using Whisper?"

**Wait for user confirmation before continuing.**

### Step 1: Check for Whisper Installation

```bash
command -v whisper
```

If not installed, ask user: "Whisper is not installed. Install it with `pip install openai-whisper` (requires ~1-3GB for models)? This is a one-time installation."

**Wait for user confirmation before installing.**

Install if approved:
```bash
pip3 install openai-whisper
```

### Step 2: Transcribe with Whisper

```bash
# Auto-detect language (recommended)
whisper VIDEO.mp4 --model base --output_format vtt

# Or specify language if known (if it is provided by the user)
whisper VIDEO.mp4 --model base --language en --output_format vtt
```

**Model Options** (stick to `base` for now):
- `tiny` - fastest, least accurate (~1GB)
- `base` - good balance (~1GB) ← **USE THIS**
- `small` - better accuracy (~2GB)
- `medium` - very good (~5GB)
- `large` - best accuracy (~10GB)

## Post-Processing

### Convert to Plain Text (Recommended)

YouTube's auto-generated VTT files contain **duplicate lines** because captions are shown progressively with overlapping timestamps. Always deduplicate when converting to plain text while preserving the original speaking order.

```bash
python3 -c "
import sys, re
seen = set()
with open('transcript.en.vtt', 'r') as f:
    for line in f:
        line = line.strip()
        if line and not line.startswith('WEBVTT') and not line.startswith('Kind:') and not line.startswith('Language:') and '-->' not in line:
            clean = re.sub('<[^>]*>', '', line)
            clean = clean.replace('&amp;', '&').replace('&gt;', '>').replace('&lt;', '<')
            if clean and clean not in seen:
                print(clean)
                seen.add(clean)
" > transcript.txt
```

## Output Formats

- **VTT format** (`.vtt`): Includes timestamps and formatting, good for video players
- **Plain text** (`.txt`): Just the text content, good for reading or analysis

## Tips
- name the file with the video title and language (e.g., `VIDEO.en.vtt`)

## Error Handling

### Common Issues and Solutions:

**1. Whisper installation fails**
- Provide fallback: "Install manually with: `pip3 install openai-whisper`"
- Check available disk space (models require 1-10GB depending on size)

### Best Practices:

- ✅ Verify success at each step before proceeding to next
- ✅ Clean up temporary files after processing
- ✅ Provide clear feedback about what's happening at each stage
- ✅ Handle errors gracefully with helpful messages
