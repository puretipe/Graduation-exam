document.addEventListener("turbo:load", () => {
  const input = document.querySelector('#profile_image');
  const preview = document.querySelector('#preview');

  input.addEventListener('change', (event) => {
    const file = event.target.files[0];
    const reader = new FileReader();

    reader.onload = (e) => {
      preview.src = e.target.result;
      preview.style.display = 'block';
    };

    if (file) {
      reader.readAsDataURL(file);
    } else {
      preview.src = "";
      preview.style.display = 'none';
    }
  });
});
