<script>
  const renderedOutput = "";
</script>

{#if renderedOutput}
  {@html renderedOutput}
{:else}
  <!-- TODO: add all the tags so the warning of the css will be shutdown -->
  <p>Salut <span class="spoiler">ceci est un spoil</span></p>
  
{/if}

<style>
  /* Styling for markdown-rendered content */
  h1,
  h2,
  h3,
  h4,
  h5,
  h6 {
    font-family: "Arial", sans-serif;
    margin-top: 20px;
    margin-bottom: 10px;
    color: #333;
  }

  .spoiler {
    color: #fff; /* White text color */
    background-color: #000; /* Black background */
  }

  h1 {
    font-size: 2em;
    border-bottom: 1px solid #ccc;
    padding-bottom: 5px;
  }

  h2 {
    font-size: 1.8em;
    margin-top: 1em;
  }

  h3 {
    font-size: 1.5em;
  }

  p {
    margin: 10px 0;
    font-size: 1rem;
  }

  blockquote {
    margin: 10px 0;
    padding: 10px 20px;
    background-color: #f1f1f1;
    border-left: 4px solid #ccc;
    color: #666;
  }

  code {
    padding: 2px 4px;
    font-family: "Courier New", monospace;
    font-size: 0.95em;
    color: #d63384;
  }

  pre {
    background-color: #2d2d2d;
    color: #f8f8f2;
    padding: 15px;
    border-radius: 5px;
    overflow-x: auto;
    font-family: "Courier New", monospace;
  }

  pre code {
    color: #f8f8f2;
  }

  ul,
  ol {
    padding-left: 40px;
    margin: 10px 0;
  }

  ul li,
  ol li {
    margin-bottom: 5px;
  }

  a {
    color: #007bff;
    text-decoration: none;
  }

  a:hover {
    text-decoration: underline;
  }

  /* Additional customization */
  img {
    max-width: 100%;
    height: auto;
    border-radius: 4px;
  }

  hr {
    border: 0;
    height: 1px;
    background-color: #ddd;
    margin: 20px 0;
  }
</style>
