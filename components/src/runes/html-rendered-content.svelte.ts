import { renderMarkdown } from "../lib/markdown-to-message-html";
import { markdownContent } from "./markdown-content.svelte";

export function htmlRenderedContent() {
  // TODO: its for telegram only for now
  return renderMarkdown(markdownContent.content);
}
