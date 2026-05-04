Alignment settings and transcription conventions used at some point during the process of creating Tunica training data on Escriptorium. I think this was for notebook 6, and I was running alignment on 10 pages at a time using .txt files produced by create-alignment-txt-files.py.

---

# Alignment settings

+ DON'T merge aligned text with existing transcription
+ Line length .3
+ N-gram 3
+ Beam size 100
+ leave other settings untouched

# Transcription conventions

+ don't transcribe page number
+ don't transcribe crossouts/scribbles

## Region types:

+ Elicitation
+ Interlinear
+ Main (includes anything with text that doesn't clearly fit elicitation or interlinear)