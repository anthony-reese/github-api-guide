# Integrating the GitHub API using curl and Postman

![License](https://img.shields.io/github/license/anthony-reese/github-api-guide?style=flat-square&cacheBust=1)
![Stars](https://img.shields.io/github/stars/anthony-reese/github-api-guide?style=social)
![Last Commit](https://img.shields.io/github/last-commit/anthony-reese/github-api-guide)

Integrate and explore the GitHub REST API using curl and Postman.
This project provides real-world examples of API authentication, core endpoint usage (repos, issues, starring), and error handling. Includes reusable curl scripts, a Postman collection, and a clear step-by-step guide for developers, testers, and technical writers.

---

## Project Structure
```
github-api-guide/
├── postman_collection.json
├── curl-scripts/
│   ├── get-user.sh
│   └── create-issue.sh
├── assets/
│   └── postman-auth-example.png
├── README.md
└── LICENSE
```

## Setup & Authentication

### 1. Create a GitHub Personal Access Token (PAT)

1. Go to [GitHub → Settings → Developer Settings → Personal access tokens → Fine-grained tokens or Tokens (classic)](https://github.com/settings/tokens)
2. Click **"Generate new token"**
3. Select scopes:
   - `repo` (for repo access)
   - `user` (to access user data)
   - `workflow` (for GitHub Actions, optional)
4. Copy the token (e.g. `ghp_YFjQVBHMJ2tZZpkw6i...`) and store it securely.

---

### Test Authentication with curl

```bash
curl -H "Authorization: token YOUR_GITHUB_TOKEN" \
     https://api.github.com/user
```

### Example Response
```json
{
  "login": "your-username",
  "id": 201234561,
  "public_repos": 42,
  "public_gists": 13,
  ...
}
```

### Example Error (Invalid Token)
```json
{
  "message": "Bad credentials",
  "documentation_url": "https://docs.github.com/rest",
  "status": "401"
}
```

### Test Authentication in Postman

1. Create a new GET request to:
    ```arduino
    https://api.github.com/user
    ```

2. Under the **Authorization** tab:
    - Type: **Bearer Token**
    - Token: `YOUR_GITHUB_TOKEN`

3. Click **Send** → You should see your user profile response.


## Core API Use Cases

### List Repositories for Authenticated User

`GET /user/repos`

**curl:**
```bash
curl -H "Authorization: token YOUR_GITHUB_TOKEN" \
     https://api.github.com/user/repos
```

**Use case:** Get a list of all repositories you own or have access to.

### Get a Specific Repository

`GET /repos/:owner/:repo`

**curl:**
```bash
curl -H "Authorization: token YOUR_GITHUB_TOKEN" \
     https://api.github.com/repos/octocat/Hello-World
```

### Create a New Repository

`POST /user/repos`

**curl:**
```bash
curl -X POST https://api.github.com/user/repos \
     -H "Authorization: token YOUR_GITHUB_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"test-repo-from-api","private":false}'
```

### Create an Issue

`POST /repos/:owner/:repo/issues`

**curl:**
```bash
curl -X POST https://api.github.com/repos/YOUR_USERNAME/YOUR_REPO/issues \
     -H "Authorization: token YOUR_GITHUB_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"title":"Bug report","body":"There is a bug here."}'
```

### Star a Repository

`PUT /user/starred/:owner/:repo`

**curl:**
```bash
curl -X PUT -H "Authorization: token YOUR_GITHUB_TOKEN" \
     -H "Content-Length: 0" \
     https://api.github.com/user/starred/octocat/Hello-World
```

## Response Handling & Error Cases

Understanding how the GitHub API responds, especially in error scenarios, is key for debugging and robust integration.

### Successful Response Example

Most GitHub API responses on success return:

- 200 OK for GET or PUT

- 201 Created for POST

- JSON body with relevant data

### Example – Get Authenticated User:

```http
HTTP/1.1 200 OK
Content-Type: application/json
```

```json
{
  "login": "your-username",
  "id": 1234567,
  "name": "Your Name",
  "public_repos": 12,
  ...
}
```

### Common Error Responses

| Status | Cause                            | How to Fix                                            |
|--------|----------------------------------|-------------------------------------------------------|
| 401    | Unauthorized (Bad Token)         | Check `Authorization` header or token scopes          |
| 403    | Forbidden (Rate Limit or Scopes) | Wait for reset or adjust token permissions            |
| 404    | Not Found (Wrong URL or Repo)    | Check owner/repo names and auth context               |
| 422    | Validation Failed (Bad payload)  | Fix JSON body, ensure required fields present scopes  |
| 500    | Server Error                     | Retry later (GitHub issue)                            |

### Testing Errors with curl

#### Invalid Token

```bash
curl -H "Authorization: token invalid_token" https://api.github.com/user
```

#### Response:

```json
{
  "message": "Bad credentials",
  "documentation_url": "https://docs.github.com/rest"
}
```

### Rate Limiting

GitHub API uses two types of rate limits:

- **Unauthenticated:** 60 requests/hour

- **Authenticated:** 5000 requests/hour (with token)

To check your rate limit:

```bash
curl -H "Authorization: token YOUR_GITHUB_TOKEN" \
     https://api.github.com/rate_limit
```

#### Response Example:

```json
{
  "rate": {
    "limit": 5000,
    "remaining": 4998,
    "reset": 1723782053
  }
}
```

To convert `reset` UNIX timestamp:

```bash
date -d @1723782053
```

### Error Tips in Postman

- Use **Tests** tab to assert status codes:

```js
pm.test("Status is 200", () => {
  pm.response.to.have.status(200);
});
```

- Handle missing or invalid tokens:

```js
if (pm.response.code === 401) {
  console.warn("Unauthorized – Check your token!");
}
```

## curl-scripts

You can run demo API calls via CLI by using the scripts in `/curl-scripts`.

### Setup
Export your token before running any script:

```bash
export GITHUB_TOKEN=ghp_your_personal_access_token
```

| **Script**             | **Description**                |
|------------------------|--------------------------------|
| get-user.sh            | Get authenticated user info    |
| list-repos.sh          | List all repos for user        |
| create-repo.sh         | Create a new public repo       |
| create-issue.sh        | Open an issue in a test repo   |
| star-repo.sh           | Star a repo via curl           |

Run with:

```bash
./curl-scripts/create-repo.sh test-repo
```

## LICENSE

This project is licensed under the [MIT License](./LICENSE).