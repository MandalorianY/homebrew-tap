class Jobsfr < Formula
  include Language::Python::Virtualenv

  desc "Job scraper and Excel application tracker for France"
  homepage "https://github.com/MandalorianY/french-job-scraper"
  url "https://github.com/MandalorianY/french-job-scraper/releases/download/v0.2.0/scrapper-0.2.0.tar.gz"
  sha256 "e566ae956ba153b0e8a7027bf3fba7c42a6481f71bbc898e00213a30da8caaef"
  license "MIT"

  depends_on "uv" => :build
  depends_on "python@3.14"

  allow_network_access! :build

  def install
    virtualenv_create(libexec, python3, system_site_packages: false)
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec
    ENV["UV_PYTHON_DOWNLOADS"] = "never"
    system "uv", "sync", "--locked", "--no-dev", "--no-editable", "--no-cache"
    bin.install_symlink libexec/"bin/jobsfr"
    bin.install_symlink libexec/"bin/jobsfr-install-timer"
    bin.install_symlink libexec/"bin/job-scrapper"
    bin.install_symlink libexec/"bin/job-scrapper-install-timer"

    if OS.mac?
      workdir = var/"job-scrapper"
      workdir.mkpath
      # Homebrew requires a packaged service file even when starting with --file.
      system libexec/"bin/python", "-c", <<~PYTHON, workdir, opt_bin/"jobsfr", prefix
        import sys
        from pathlib import Path
        from scrapper.scheduling import HOMEBREW_LABEL, ScheduleConfig, _homebrew_plist

        workdir, executable, prefix = map(Path, sys.argv[1:])
        (prefix / f"{HOMEBREW_LABEL}.plist").write_bytes(_homebrew_plist(workdir, executable, ScheduleConfig(), []))
      PYTHON
    end
  end

  service do
    name macos: "homebrew.mxcl.jobsfr"
  end

  test do
    assert_match "Usage: jobsfr", shell_output("#{bin}/jobsfr --help")
    assert_match "jobsfr #{version}", shell_output("#{bin}/job-scrapper --version")
    assert_match "--profile", shell_output("#{bin}/jobsfr-install-timer --help")
  end
end
