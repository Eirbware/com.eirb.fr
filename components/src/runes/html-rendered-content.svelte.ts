import { renderMarkdown } from "../lib/markdown-to-message-html";
import { markdownContent } from "./markdown-content.svelte";

export function htmlRenderedContent() {
  return renderMarkdown(markdownContent.content);
}
