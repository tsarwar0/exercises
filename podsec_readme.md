
## Securing Pod

# What is a security context
  A security context defines priviliges for condtainers and pods. It is used to grant pods and containers permissions such as rights to access a resource or run in privilied mode.

  This sample pod configuration has following security features enabled:
  - The container runs as a non-root user.
  - The root filesystem of the container is read-only.
  - Privilege escalation is disabled.
  - All Linux capabilities are dropped.
  - A default seccomp profile is enforced.
  - Resource utilization is enforced so that no container consume more than defined params and take over cluster resources.

  These settings restrict the privileges available to the application, enhancing the overall security of the deployment and help minimizing the attack surface.

  Please refer to configuration pod code - [pod-security](./pod-security/)

  
