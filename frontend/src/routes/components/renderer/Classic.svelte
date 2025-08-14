<script lang="ts">
	import './css/classic-renderer.css';

	import { browser } from '$app/environment';

	let { htmlContent }: { htmlContent: string } = $props();
</script>

<div class="rendered-html">
	<!-- client-side rendering only (remove conflict with inexisting SSR) -->
	{#if browser}
		{@html htmlContent}
	{/if}
</div>
