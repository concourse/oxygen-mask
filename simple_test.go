package oxygen_mask_test

import (
	"fmt"
	"os"
	"os/exec"
	"time"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gbytes"
	"github.com/onsi/gomega/gexec"
)

var _ = Describe("Viewing a public pipeline", func() {
	BeforeEach(func() {
		if !which("google-chrome-stable") {
			Skip("These tests require google-chrome-stable to run")
		}

		fly("set-pipeline", "-p", "oxygen-mask", "-c", "fixtures/pipeline.yml")
	})

	getEnv := func(name string) string {
		value := os.Getenv(name)
		if value == "" {
			panic("Required to have environment variable -- " + name)
		}
		return value
	}

	pipelineURL := func() string {
		return fmt.Sprintf("%s/teams/%s/pipelines/%s", getEnv("ATC_URL"), getEnv("TEAM_NAME"), getEnv("PIPELINE_NAME"))
	}

	Context("checking a job exists", func() {
		It("render in quickly", func() {
			cmd := exec.Command(
				"google-chrome-stable",
				"--no-sandbox",
				"--timeout=1000",
				"--virtual-time-budget=1000",
				"--disable-gpu",
				"--headless",
				"--dump-dom",
				pipelineURL(),
			)

			session, err := gexec.Start(cmd, GinkgoWriter, GinkgoWriter)
			Expect(err).To(Succeed())

			Eventually(session, 1*time.Second).Should(gbytes.Say("simple-job"))
			emitDatadogMetric("concourse.view_public_pipeline", 1)
		})

		AfterEach(func() {
			desc := CurrentGinkgoTestDescription()
			if desc.Failed {
				emitDatadogMetric("concourse.view_public_pipeline", 1)
			}

		})
	})
})
