import re
from typing import Dict, Set

WHITESPACE_REGEX = re.compile(r'\s+')

SG_CHAR_VOCAB = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w',
    'x', 'y', 'z', 'ä', 'ö', 'ü', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ' ',
}

SG_CHAR_LOOKUP = {
    'á': 'a',
    'à': 'a',
    'â': 'a',
    'ç': 'c',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'í': 'i',
    'ì': 'i',
    'î': 'i',
    'ñ': 'n',
    'ó': 'o',
    'ò': 'o',
    'ô': 'o',
    'ú': 'u',
    'ù': 'u',
    'û': 'u',
    'ș': 's',
    'ş': 's',
    'ß': 'ss',
    '-': ' ',
    # Not used consistently, better to replace with space as well:
    '–': ' ',
    '/': ' ',
}


def normalize_text(text: str, char_vocab: Set[str], char_lookup: Dict[str, str]):
    text = text.lower()
    for q, r in char_lookup.items():
        text = text.replace(q, r)

    text = WHITESPACE_REGEX.sub(' ', text)
    text = ''.join([char for char in text if char in char_vocab])
    text = WHITESPACE_REGEX.sub(' ', text)
    text = text.strip()
    return text