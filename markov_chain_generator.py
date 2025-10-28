import os
import random
import re

def get_markdown_files(root_dir="."):
    md_files = []
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith(".md"):
                md_files.append(os.path.join(dirpath, filename))
    return md_files

def tokenize(text):
    return re.findall(r"\b\w+\b|[.!?]", text)

def build_markov_chain(tokens):
    chain = {}
    for i in range(len(tokens)-1):
        key = tokens[i]
        nxt = tokens[i+1]
        chain.setdefault(key, []).append(nxt)
    return chain

def generate_sentence(chain, length=25):
    word = random.choice([w for w in chain if w[0].isupper()])
    sentence = [word]
    for _ in range(length):
        next_words = chain.get(word)
        if not next_words:
            break
        word = random.choice(next_words)
        sentence.append(word)
        if word in ".!?":
            break
    return ' '.join(sentence)

def main():
    files = get_markdown_files(".")
    all_text = ""
    for f in files:
        with open(f, "r", encoding="utf-8") as file:
            all_text += file.read() + " "
    tokens = tokenize(all_text)
    if not tokens:
        print("No tokens found in Markdown files.")
        return
    chain = build_markov_chain(tokens)
    print("=== Silly Markov Chain Sentences ===")
    for _ in range(10):
        print(generate_sentence(chain))

if __name__ == "__main__":
    main()