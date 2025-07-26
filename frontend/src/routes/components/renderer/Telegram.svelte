<script lang="ts">
	import 'highlight.js/styles/default.css';
	import './css/telegram-renderer.css';
	import './css/telegram-new-renderer.css';

	import { browser } from '$app/environment';

	let { htmlContent }: { htmlContent: string } = $props();
	function renderSulgukCaveats(content: string) {
		/* Edit the HTML to add newlines around the code blocks, which is forced by
		 * the sulguk intergration in the backend.
		 */
		// TODO:
		return content;
	}
	function renderCodeHeader(content: string) {
		const parser = new DOMParser();
		const rendered = parser.parseFromString(content, 'text/html');
		const codeHeader = (language: string) => {
			const newElt = rendered.createElement('div');
			newElt.classList.add('code-header');
			newElt.innerHTML = `<span class="code-header-name">${language.charAt(0).toUpperCase() + language.slice(1)}</span>
<span class="code-header-button"></span>
<span class="code-header-button"></span>`;
			return newElt;
		};
		rendered.querySelectorAll('pre').forEach((preElt) => {
			const codeBlock = preElt.querySelector('code');
			if (codeBlock === null) return;
			const codeBlockLanguage = codeBlock.classList[1].split('language-')[1];
			preElt.insertBefore(codeHeader(codeBlockLanguage), codeBlock);
		});
		return rendered.documentElement.outerHTML;
	}

	function htmlToDisplayedHTML(content: string) {
		return renderSulgukCaveats(renderCodeHeader(content));
	}
</script>

<div class="telegram-bubble-content-wrapper">
	<div class="telegram-bubble-content">
		<div class="telegram-message-wrapper">
			<div class="telegram-message">
				{#if browser}
					{@html htmlToDisplayedHTML(htmlContent)}
				{/if}
			</div>
		</div>
	</div>
</div>

<div class="rendered-telegram">
	<div class="page_body chat_page">
		<div class="message default clearfix">
			<div class="pull_left userpic_wrap">
				<div class="userpic userpic6" style="width: 42px; height: 42px">
					<div class="initials" style="line-height: 42px"></div>
				</div>
			</div>

			<div class="body">
				<!-- TODO: add the automatic date -->
				<div class="pull_right date details" title="14.04.2025 00:01:51 UTC+01:00">00:01</div>

				<!-- TODO: add an default User -->
				<div class="from_name">💚🩵Feufoll'eirb🩵💚</div>

				<!-- TODO: insert html here -->
				<div class="text" id="rendered-content">
					<!-- client-side rendering only (remove conflict with inexisting SSR) -->
					{#if browser}
						{@html htmlContent}
					{/if}
				</div>

				<span class="reactions">
					<span class="reaction">
						<span class="emoji"> ❤ </span>

						<span class="count"> 17 </span>
					</span>

					<span class="reaction">
						<span class="emoji"> 🔥 </span>

						<span class="count"> 4 </span>
					</span>

					<span class="reaction">
						<span class="emoji"> 🎉 </span>

						<span class="count"> 1 </span>
					</span>
				</span>
			</div>
		</div>
	</div>
</div>
