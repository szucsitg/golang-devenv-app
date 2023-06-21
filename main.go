package main

import (
  "go.uber.org/zap"
)

func main() {
  logger, _ := zap.NewProduction()
  defer logger.Sync()
  sugar := logger.Sugar()
  sugar.Info("application started")
}
