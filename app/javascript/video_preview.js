function updateVideoPreview(url) {
  const videoFrame = document.getElementById('videoFrame');
  const videoPreviewDiv = document.getElementById('dynamicVideoPreview');

  const ytMatch = url.match(/\b(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([\w\-]+)/i) || url.match(/\b(?:https?:\/\/)?(?:www\.)?youtu\.be\/([\w\-]+)/i);
  const nicoMatch = url.match(/\b(?:https?:\/\/)?(?:www\.)?nicovideo\.jp\/watch\/([\w\-]+)/i);
  
  if (ytMatch && ytMatch[1]) {
      videoFrame.src = 'https://www.youtube.com/embed/' + ytMatch[1];
      videoPreviewDiv.style.display = 'block';
  } else if (nicoMatch && nicoMatch[1]) {
      videoFrame.src = 'https://embed.nicovideo.jp/watch/' + nicoMatch[1];
      videoPreviewDiv.style.display = 'block';
  } else {
      videoFrame.src = '';
      videoPreviewDiv.style.display = 'none';
  }
}
window.updateVideoPreview = updateVideoPreview;
