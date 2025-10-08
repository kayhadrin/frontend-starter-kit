'use client';

import Demo from '@/components/Demo.react';

export default function Home() {
  return (
    <div className="grid min-h-screen grid-rows-[20px_1fr_20px] items-center justify-items-center gap-16 p-8 pb-20 font-sans sm:p-20">
      <main className="row-start-2 flex flex-col items-center gap-[32px] sm:items-start">
        <h1 className="text-4xl font-bold sm:text-5xl">Demo title</h1>

        <Demo />
      </main>
    </div>
  );
}
