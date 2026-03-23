package claude

import (
	. "github.com/opa-ai-labs/opa-api/v6/internal/constant"
	"github.com/opa-ai-labs/opa-api/v6/internal/interfaces"
	"github.com/opa-ai-labs/opa-api/v6/internal/translator/translator"
)

func init() {
	translator.Register(
		Claude,
		OpenAI,
		ConvertClaudeRequestToOpenAI,
		interfaces.TranslateResponse{
			Stream:     ConvertOpenAIResponseToClaude,
			NonStream:  ConvertOpenAIResponseToClaudeNonStream,
			TokenCount: ClaudeTokenCount,
		},
	)
}
