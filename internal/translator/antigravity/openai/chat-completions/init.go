package chat_completions

import (
	. "github.com/opa-ai-labs/opa-api/v6/internal/constant"
	"github.com/opa-ai-labs/opa-api/v6/internal/interfaces"
	"github.com/opa-ai-labs/opa-api/v6/internal/translator/translator"
)

func init() {
	translator.Register(
		OpenAI,
		Antigravity,
		ConvertOpenAIRequestToAntigravity,
		interfaces.TranslateResponse{
			Stream:    ConvertAntigravityResponseToOpenAI,
			NonStream: ConvertAntigravityResponseToOpenAINonStream,
		},
	)
}
