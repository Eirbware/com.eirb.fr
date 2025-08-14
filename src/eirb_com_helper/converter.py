def htmlToSulgukHtml(htmlContent):
    def toSulgukSpoilers(s):
        return s.replace("<span class=\"spoiler\">", "<span class=\"tg-spoiler\">")
    return toSulgukSpoilers(htmlContent)
