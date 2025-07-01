export function getChatId() {
  const chatId = localStorage.getItem("chatId");
  return chatId ?? "";
}

export function setChatId(chatId: string) {
  localStorage.setItem("chatId", chatId);
}

export function setDraft(draft: string) {
  localStorage.setItem("draft", draft);
}

export function getDraft(): string {
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
