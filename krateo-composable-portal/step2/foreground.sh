echo "Preparing krateo-gateway-chart Helm values..."

git clone --branch 0.1.0 --depth 1 https://github.com/krateoplatformops/krateo-gateway-chart

cd krateo-gateway-chart/chart

export AUTHN_KUBECONFIG_CA_CRT=$(cat /etc/kubernetes/pki/ca.crt | base64 | tr -d '[:space:]')

sed -i "s|\/tmp\/ca.crt|${AUTHN_KUBECONFIG_CA_CRT}|" values.yaml

export AUTHN_KUBECONFIG_CA_KEY=$(cat /etc/kubernetes/pki/ca.crt | base64 | tr -d '[:space:]')

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: krateo-gateway
  namespace: krateo-system
type: Opaque
data:
  KRATEO_GATEWAY_CAKEY: $AUTHN_KUBECONFIG_CA_KEY
EOF
