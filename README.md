# ExquisiteShell

Here’s one way to build a playful little “exquisite corpse” generator in Bash, rummaging through a folder of text files (each containing lines from your favorite authors). This script randomly stitches partial lines together, forging whimsical narrative fragments. Along the way, we’ll add a dusting of sed/awk magic.

The Idea
We keep a directory (e.g. ./literary_passages/) filled with text files—each a small anthology from a particular author or multiple authors.
Our script picks a certain number of lines from different files, chops or transforms them in surprising ways, and concatenates them into short “mini-stories.”

How it Works
File Gathering: We define TEXT_DIR="./literary_passages". You can tweak this to any folder you like. The script reads all text files found there and dumps them into the FILES array.
Random Line Retrieval: We loop LINES_PER_SNIPPET times, each time picking a random file, counting its lines, and extracting a single random line.
Sed & Awk Transformations: For comedic effect:
We slip snicker after the third word using awk if the line has at least three words.
We uppercase the first five characters with sed.
Concatenation: We gather these lines into a short snippet, separated by newline boundaries and playful punctuation.
Usage
Create a folder literary_passages in the same directory as exquisite_shell.sh.
Place a handful of text files there (e.g. lovecraft.txt, whitman.txt, woolf.txt). Each file should have at least a few lines—random lines, quotes, or entire paragraphs.
Run the script:
bash
Copy code
chmod +x exquisite_shell.sh
./exquisite_shell.sh
Observe the weird and wonderful mini-stories.
A playful next step? Add more transformations. For instance, you could:

Randomly shuffle the words in each line with awk '{for(i=1;i<=NF;i++) a[i]=$i; srand(); for(i=1;i<=NF;i++){ j=int(rand()*NF)+1; tmp=a[i]; a[i]=a[j]; a[j]=tmp;} for(i=1;i<=NF;i++)printf("%s ",a[i]); print ""}'.
Insert random punctuation (“?!...”, etc.) in the middle of lines to enhance the comedic effect.
Increase LINES_PER_SNIPPET or shuffle the resulting lines themselves after extraction.
May you delight in the textual chimera this script conjures—and if you find yourself craving more unhinged word collisions, tweak away. There’s no limit to the joys of diving headfirst into the textual labyrinth and forging your own poetic (or comedic) collisions.

If you’d like to push further, ask the script to branch out beyond simple transformations. For instance:

“Could you generate additional random lines but apply a Markov chain approach for each line’s second half?”
“What if we incorporate a frequency-based rewriting that swaps synonyms at random intervals?”
You might be pleasantly surprised at the emergent mischief your script can brew. Enjoy!
