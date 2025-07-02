export function postMessage(htmlMsg: string, chat_id: string) {
  // /send is the API endpoint of the flask server, accessible
  // when the vite components are mounted in the jinja templates
  fetch("/send", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ chat_id, content_type: "html", content: htmlMsg }),
  })
    .then((response) => {
      if (response.ok)
        response.text().then((resMessage) => {
          alert("Ok: " + resMessage);
        });
      else
        throw new Error(
          "The message have not been sent. Please edit your input.",
        );
    })
    .catch((err) => alert(err));
}
