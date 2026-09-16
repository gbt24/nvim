type User = { id: number; name: string };

export function greeting(user: User): string {
  return `Hello, ${user.name}`;
}
