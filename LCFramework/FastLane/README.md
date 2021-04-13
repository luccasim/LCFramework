#  FastLane

For CD

## Lane Pour TestFligh

lane :send do
    increment_build_number
      build_app(scheme: "iOS-poc")
      upload_to_testflight(username: "casimir.luc@gmail.com")
    slack(
        slack_url: "https://hooks.slack.com/services/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",
        message: "Successfully distributed a new beta build"
    )
end

## Créer un slack webhook

[incoming-webhook](https://arc-n5t2218.slack.com/apps/new/A0F7XDUAZ-incoming-webhooks)
