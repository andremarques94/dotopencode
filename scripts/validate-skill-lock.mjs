#!/usr/bin/env node
import { readdir, readFile } from "node:fs/promises";
import { existsSync } from "node:fs";
import { join } from "node:path";

const lockPath = ".agents/.skill-lock.json";
const skillsRoot = ".agents/skills";

if (!existsSync(lockPath)) {
  throw new Error("Missing .agents/.skill-lock.json");
}

if (!existsSync(skillsRoot)) {
  throw new Error("Missing .agents/skills directory");
}

const lock = JSON.parse(await readFile(lockPath, "utf8"));

if (!lock.skills || typeof lock.skills !== "object" || Array.isArray(lock.skills)) {
  throw new Error(".agents/.skill-lock.json must contain a top-level skills object");
}

const skillEntries = await readdir(skillsRoot, { withFileTypes: true });
const skillDirs = new Set(
  skillEntries.filter((entry) => entry.isDirectory()).map((entry) => entry.name),
);
const lockedSkills = new Set(Object.keys(lock.skills));

const missingFromLock = [...skillDirs]
  .filter((name) => !lockedSkills.has(name))
  .sort();
const missingFromDisk = [...lockedSkills]
  .filter((name) => !skillDirs.has(name))
  .sort();
const missingSkillMd = skillEntries
  .filter((entry) => entry.isDirectory())
  .map((entry) => entry.name)
  .filter((name) => !existsSync(join(skillsRoot, name, "SKILL.md")))
  .sort();

if (missingFromLock.length || missingFromDisk.length || missingSkillMd.length) {
  printList("Skill directories missing from lock", missingFromLock);
  printList("Lock entries missing from disk", missingFromDisk);
  printList("Skill directories missing SKILL.md", missingSkillMd);
  process.exitCode = 1;
} else {
  console.log(`Skill lock matches ${skillDirs.size} skill directories.`);
}

function printList(title, items) {
  if (!items.length) {
    return;
  }

  console.log(`${title}:`);
  for (const item of items) {
    console.log(`- ${item}`);
  }
}
