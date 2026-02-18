/**
 * User controller - HTTP request handling layer.
 *
 * References UserDTO and UserService - will be affected by rename refactoring.
 */

import type { UserDTO, CreateUserDTO, UpdateUserDTO } from "./types";
import { UserService } from "./service";

interface Request {
  params: Record<string, string>;
  body: unknown;
  query: Record<string, string>;
}

interface Response {
  status(code: number): Response;
  json(data: unknown): void;
  send(message: string): void;
}

export class UserController {
  private userService: UserService;

  constructor() {
    this.userService = new UserService();
  }

  async list(req: Request, res: Response): Promise<void> {
    const users = await this.userService.getAll();
    res.status(200).json({ data: users, total: users.length });
  }

  async show(req: Request, res: Response): Promise<void> {
    const user: UserDTO | null = await this.userService.getById(req.params.id);
    if (!user) {
      res.status(404).json({ error: "UserDTO not found" });
      return;
    }
    res.status(200).json({ data: user });
  }

  async create(req: Request, res: Response): Promise<void> {
    const data = req.body as CreateUserDTO;
    if (!data.username || !data.email) {
      res.status(400).json({ error: "Username and email are required for UserDTO" });
      return;
    }
    const user: UserDTO = await this.userService.create(data);
    res.status(201).json({ data: user });
  }

  async update(req: Request, res: Response): Promise<void> {
    const data = req.body as UpdateUserDTO;
    const user: UserDTO = await this.userService.update(req.params.id, data);
    res.status(200).json({ data: user });
  }

  async delete(req: Request, res: Response): Promise<void> {
    await this.userService.delete(req.params.id);
    res.status(204).send("");
  }
}
