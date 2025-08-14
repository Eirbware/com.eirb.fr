import { browser } from "$app/environment";

export function getChatId() {
  if (!browser) return "";
  const chatId = localStorage.getItem("chatId");
  return chatId ?? "";
}

export function setChatId(chatId: string) {
  if (!browser) return;
  localStorage.setItem("chatId", chatId);
}

export function setDraft(draft: string) {
  if (!browser) return;
  localStorage.setItem("draft", draft);
}

export function getDraft(): string {
  if (!browser) return "";
  const draft = localStorage.getItem("draft");
  return draft ?? "";
}

/**
 * Remove all entries from the store
 */
function clearStore() {
  setChatId("");
  setDraft("");
}

/**
 * Set entries in the store from JSON data
 */
function loadStore(store: { chatId: string; draft: string }) {
  setChatId(store.chatId);
  setDraft(store.draft);
}

function exportStore(): { chatId: string; draft: string } {
  return {
    chatId: getChatId(),
    draft: getDraft(),
  };
}
