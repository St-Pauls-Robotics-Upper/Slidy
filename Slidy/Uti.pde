enum FontSize { title, body, caption }

void centerAlignedWord(String content, int yPos, FontSize font) {
  switch (font) {
    case title: 
      textFont(titleFont);
    break;
    case body: 
      textFont(bodyFont);
    break;
    case caption: 
      textFont(captionFont);
    break;
  }
  
  
  text(content, (width - textWidth(content))/2, yPos);
}
