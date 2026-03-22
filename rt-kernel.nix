{
  flake.modules.nixos.rt =
    {
      lib,
      pkgs,
      ...
    }:
    {
      specialisation.rt.configuration = {
        powerManagement.cpuFreqGovernor = lib.mkForce "performance";

        boot.kernelParams = [
          "nohz_full=1-15"
          "rcu_nocbs=1-15"
          "rcu_nocb_poll"
          "irqaffinity=0"
          "skew_tick=1"
          "amd_pstate=passive"
          "processor.max_cstate=1"
        ];

        boot.kernel.sysctl = {
          "kernel.sched_rt_runtime_us" = -1;
          "kernel.timer_migration" = 0;
        };

        security.pam.loginLimits = [
          {
            domain = "@audio";
            type = "-";
            item = "rtprio";
            value = "98";
          }
          {
            domain = "@audio";
            type = "-";
            item = "memlock";
            value = "unlimited";
          }
        ];

        services.irqbalance.enable = false;

        boot.kernelPackages = lib.mkForce (
          pkgs.linuxPackagesFor (
            pkgs.linuxKernel.kernels.linux_latest.override {
              ignoreConfigErrors = true;
              structuredExtraConfig = with lib.kernel; {
                PREEMPT = lib.mkForce yes;
                PREEMPT_RT = yes;
                PREEMPT_VOLUNTARY = lib.mkForce no;
                HIGH_RES_TIMERS = yes;
                HZ_1000 = yes;
                NO_HZ_FULL = yes;
                CPU_FREQ_DEFAULT_GOV_PERFORMANCE = yes;
                LOCKUP_DETECTOR = lib.mkForce no;
                DETECT_HUNG_TASK = lib.mkForce no;
                HWLAT_TRACER = yes;
              };
            }
          )
        );
      };
    };
}
