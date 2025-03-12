function copyCode() {
    const codeText = document.getElementById('code').innerText;
    navigator.clipboard.writeText(codeText.trim())
        .then(() => {
            // Display the "Copied!" message
            const copyMessage = document.getElementById('copyMessage');
            copyMessage.style.display = 'inline'; // Make it visible
            setTimeout(() => {
                copyMessage.style.display = 'none'; // Hide after 2 seconds
            }, 2000);
        })
        .catch(err => {
            console.error('Failed to copy code:', err);
        });
}