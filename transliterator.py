"""
An utility module for transliterating strings.
"""


def transliterate(text: str) -> str:
    """
    Transliterate a string according to the Bulgarian standards.

    :param str text: The text to be transliterated.
    :returns: The transliterated text.
    :rtype: str
    """
    bg_ch_basic = ('абвгдезийклмнопрстфхуАБВГДЕЗИЙКЛМНОПРСТФХУ',
                   'abvgdeziyklmnoprstfhuABVGDEZIYKLMNOPRSTFHU')
    bg_ch_composite = {
        'ж': 'zh',
        'ц': 'ts',
        'ч': 'ch',
        'ш': 'sh',
        'щ': 'sht',
        'ъ': 'a',
        'ь': 'y',
        'ю': 'yu',
        'я': 'ya',
        'Ж': 'Zh',
        'Ц': 'Ts',
        'Ч': 'Ch',
        'Ш': 'Sh',
        'Щ': 'Sht',
        'Ъ': 'A',
        'Ь': 'Y',
        'Ю': 'Yu',
        'Я': 'Ya',
    }

    basic_chars = str.maketrans(*bg_ch_basic)
    composite_chars = str.maketrans(bg_ch_composite)
    transl_table = {**basic_chars, **composite_chars}

    transl_raw = [w.translate(transl_table) for w in text.split()]

    # Handle words that end in 'iya' -> 'ia'
    transl_list = [w[:-3]+'ia' if w[-3:] == 'iya' else w for w in transl_raw]

    translation = ' '.join(transl_list)
    return translation
