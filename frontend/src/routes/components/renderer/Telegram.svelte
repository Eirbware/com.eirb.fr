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
		// TODO: for now, this preview is done only visually within the css
		return content;
	}
	function renderCodeHeader(content: string) {
    // TODO: use cheerio instead of the browser's dom
		const parser = new DOMParser();
		const rendered = parser.parseFromString(content, 'text/html');
		const codeHeader = (language: string | undefined) => {
			const newElt = rendered.createElement('div');
			newElt.classList.add('code-header');
			newElt.innerHTML = `<span class="code-header-name">${language ? language.charAt(0).toUpperCase() + language.slice(1) : 'copy'}</span>
<span class="code-header-button"></span>
<span class="code-header-button"></span>`;
			return newElt;
		};
		rendered.querySelectorAll('pre').forEach((preElt) => {
			const codeBlock = preElt.querySelector('code');
			if (codeBlock === null) return;
			const codeBlockLanguage: string | undefined = codeBlock.classList[1]?.split('language-')[1];
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
