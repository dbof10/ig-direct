

export function truncate (text, length) {
    return text.length > length ? `${text.substr(0, length)} ...` : text;
}
