const http = require('http');
const https = require('https');
const { exec } = require('child_process');
const crypto = require('crypto');

const PORT = 3000;
const REDIRECT_URI = `http://localhost:${PORT}/callback`;
const CURSOR_CLIENT_ID = 'c1179daa-2c10-429a-9ccb-4ba48f7b550d';

const [,, resourceUrl] = process.argv;

if (!resourceUrl) {
    console.log('Usage: node mcp-handshake.js <resource-url>');
    process.exit(1);
}

const metadataUrl = `${resourceUrl.replace(/\/$/, '')}/.well-known/oauth-protected-resource`;

async function startHandshake() {
    // 1. Fetch Metadata
    const metadata = await new Promise((resolve, reject) => {
        https.get(metadataUrl, (res) => {
            let data = '';
            res.on('data', c => data += c);
            res.on('end', () => resolve(JSON.parse(data)));
        }).on('error', reject);
    });

    const authBase = metadata.authorization_servers[0].replace(/\/$/, '');
    const codeVerifier = crypto.randomBytes(32).toString('base64url');
    const codeChallenge = crypto.createHash('sha256').update(codeVerifier).digest('base64url');

    // 2. Start Local Callback Server
    http.createServer((req, res) => {
        const url = new URL(req.url, `http://${req.headers.host}`);
        if (url.pathname === '/callback') {
            const code = url.searchParams.get('code');
            res.end('<h1>Success</h1><p>Auth code received. Check your terminal for the token.</p>');

            // 3. Exchange Code for Access Token
            const postData = new URLSearchParams({
                grant_type: 'authorization_code',
                client_id: CURSOR_CLIENT_ID,
                code: code,
                redirect_uri: REDIRECT_URI,
                code_verifier: codeVerifier
            }).toString();

            const tokenReq = https.request(`${authBase}/token`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            }, (tokenRes) => {
                let body = '';
                tokenRes.on('data', c => body += c);
                tokenRes.on('end', () => {
                    const data = JSON.parse(body);
                    
                    console.log('\n--- AUTHENTICATION COMPLETE ---');
                    console.log('Final JSON for your tokens.json:');
                    console.log(JSON.stringify({
                        access_token: data.access_token,
                        token_type: "bearer"
                    }, null, 2));
                    console.log('\n--- END ---\n');
                    
                    process.exit(0);
                });
            });
            tokenReq.write(postData);
            tokenReq.end();
        }
    }).listen(PORT);

    // 4. Construct Auth URL and Open Browser
    const authUrl = new URL(`${authBase}/authorize`);
    authUrl.searchParams.append('response_type', 'code');
    authUrl.searchParams.append('client_id', CURSOR_CLIENT_ID);
    authUrl.searchParams.append('code_challenge', codeChallenge);
    authUrl.searchParams.append('code_challenge_method', 'S256');
    authUrl.searchParams.append('redirect_uri', REDIRECT_URI);
    authUrl.searchParams.append('resource', resourceUrl);
    if (metadata.scopes_supported) {
        authUrl.searchParams.append('scope', metadata.scopes_supported.join(' '));
    }

    console.log(`🌐 Opening browser for: ${resourceUrl}`);
    const start = (process.platform === 'darwin' ? 'open' : process.platform === 'win32' ? 'start' : 'xdg-open');
    exec(`${start} "${authUrl.toString()}"`);
}

startHandshake().catch(err => {
    console.error('Error:', err.message);
    process.exit(1);
});
