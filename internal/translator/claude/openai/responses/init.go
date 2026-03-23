package responses

import (
	. "github.com/opa-ai-labs/opa-api/v6/internal/constant"
	"github.com/opa-ai-labs/opa-api/v6/internal/interfaces"
	"github.com/opa-ai-labs/opa-api/v6/internal/translator/translator"
)

func init() {
	translator.Register(
		OpenaiResponse,
		Claude,
		ConvertOpenAIResponsesRequestToClaude,
		interfaces.TranslateResponse{
			Stream:    ConvertClaudeResponseToOpenAIResponses,
			NonStream: ConvertClaudeResponseToOpenAIResponsesNonStream,
		},
	)
}
